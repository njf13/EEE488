%----------------------------------------------------------------
% Function:
% Main (dendrite_radial_voltage_ramp)
%----------------------------------------------------------------
% Arguments:
% argc = 0
%
% Returns:
% None
%----------------------------------------------------------------
% Dependencies:
% SpawnParticle
% DrawPlot
%----------------------------------------------------------------
% Description:
% Main script for particle transport sim. Change parameters undersection
% "Sim Parameters" to modify simulation behavior.
%----------------------------------------------------------------
close all;
clear all;
home;
% sim start time
time_start = datestr(now);
fprintf('Sim started: %s\n', time_start)
ii = 1; % generic sentinel var i
jj = 1; % generic sentinel var j
%% Sim Parameters
%
%
particles_to_spawn = 200; % number of particles to spawn duringsim (set '0' for no replenishment)
particle_spawn_time = inf; % time units between particle spawns(set 'inf' for only replenishment)
init_cathode_size = 2; % radius of particle circle to place atthe cathode at init (set '0' for no size)
init_particle_count = 400; % number of particles in grid at init(set '0' for no particles)
grid_radius = 50; % size of grid space
t = 3000; % max sim time
connectivity_list = [0,0,0,0];
last_bind_count=0;
%% Physical Parameters
%
%
% parameters (user-defined)
start_V = 0.4; % start of voltage ramp (V) (if V_ramp_time = 0,this is the applied V)
end_V = 4; % end of voltage ramp (V)
V_ramp_time = 10000; % # time units to ramp voltage (set '0' forno ramp)
lattice_const = 3e-10; % barrier width (m)
Wa0 = 0.5; % barrier height (eV)
T = 300; % temperature (K)
v = 1; % hopping frequency
% constants
kb = 8.617e-5; % boltzmann constant (eV/K)
e0 = 8.854e-12; % vacuum permittivity (F/m)
ze = 1.602e-19; % cation charge (eV)
% derived constants
ke = 1/(4*pi*e0); % Coulomb constant (m/F)
% parameters (derived)
vt = kb*T; % thermal voltage (eV)
Wa0_eff = Wa0 - vt; % thermally adjusted barrier height (eV)
if (V_ramp_time == 0) % applied V at cathode (V)
    V = start_V;
else
    V(ii) = start_V;
    for ii = 2:V_ramp_time
    V(ii) = V(ii-1) + (1/V_ramp_time) * (end_V - start_V);
    end
    V(V_ramp_time+1) = end_V;
end
for ii = (size(V,2)+1):t
    V(ii) = V(ii-1);
end
%% Structural Definition
%
%
center = 0; % center of grid
%% Init Grid Occupancy
%
%
existing_particles = 0; % number of particles in the grid
spawned_particles = 0; % number of particles spawned
all_rho =zeros(particles_to_spawn+10*init_cathode_size^2+init_particle_count, t); % rho of all particles at all times
all_theta =zeros(particles_to_spawn+10*init_cathode_size^2+init_particle_count, t); % theta of all particles at all times
bound =zeros(particles_to_spawn+10*init_cathode_size^2+init_particle_count,1); % particle location and bound state
num_bound = 0; % number of particles bound
% create particles in a circle around origin
all_rho_exist = 0;
all_theta_exist = 0;
if (init_cathode_size > 0)
    % place first particle at cathode center
    existing_particles = existing_particles + 1;
    this_rho = 0;
    this_theta = 0;
    all_rho(existing_particles,1) = this_rho;
    all_theta(existing_particles,1) = this_theta;
    all_rho_exist(existing_particles) = this_rho;
    all_theta_exist(existing_particles) = this_theta;
    bound(existing_particles) = 1;
    num_bound = num_bound + 1;
    % place remaining particles radially outward
    this_rho = 1;
    while (this_rho <= init_cathode_size)
        for this_theta = 0:.01:2*pi
            if ( sum(sqrt(all_rho_exist(:).^2+this_rho^2 - 2.*all_rho_exist(:).*this_rho.*cos(this_theta - all_theta_exist(:))) <= .99) < 1 )
                existing_particles = existing_particles +1;
                all_rho(existing_particles,1) = this_rho;
                all_theta(existing_particles,1) =this_theta;
                all_rho_exist(existing_particles) =this_rho;
                all_theta_exist(existing_particles) =this_theta;
                bound(existing_particles) = 1;
                num_bound = num_bound + 1;
                %record network structure here?
                
            end
        end
        this_rho = this_rho + 1;
    end
end
if (init_particle_count > 0)
    spawn_error = 0;
    spawn_rho = 'random';
    spawn_theta = 'random';
    for ii = 1:init_particle_count[all_theta(existing_particles+1,1),all_rho(existing_particles+1,1), spawn_error] =SpawnParticle(spawn_theta, spawn_rho, grid_radius,all_theta(:,1), all_rho(:,1));
        if (spawn_error)
            error('t=0 ERROR: Could not spawn particle. [init particle spawn routine]')
        end
        existing_particles = existing_particles + 1;
    end
end
num_particles = existing_particles + particles_to_spawn; % totalnumber of particles
% trim position matrices to remove excess space
all_rho = all_rho(1:num_particles,:);
all_theta = all_theta(1:num_particles,:);
bound = bound(1:num_particles);
% create single time step vectors
next_rho = all_rho(1:num_particles)'; % rho of all particles atcurrent time step
next_theta = all_theta(1:num_particles)'; % theta of allparticles are current time step
%% Particle Info
%
%
move_theta = (0:0.4:2*pi)'; % theta for random walk
diff_vec_x = zeros(num_particles,1); % diffusion vector x component
diff_vec_y = zeros(num_particles,1); % diffusion vector y component
diff_pmf_base(1:size(move_theta,1),1) = 1/size(move_theta,1); %probability weighting factors for diffusion direction
diff_pmf_barriermod = 0; % weighting factor for how much thediffusion barrier is altered by the potential source
index_rotate = floor(size(move_theta,1)/2); % derived parameterfor # of indices in pmf that span pi/2 rad
diff_pmf_size = size(diff_pmf_base,1); % size of pmf array (calconce for optimization)
drift_dir_index = zeros(num_particles,1); % index in move_thetacorresponding to drift direction
drift_dir_pi_index = zeros(num_particles,1); % index inmove_theta corresponding to drift direction + pi
time_until_hop = zeros(num_particles,1) + v; % timer for hoppingattempt frequency
%% First Particle Spawn
%
%
spawn_error = 0; % flag set if there is a problem spawningparticle 
force_particle_spawn = 0; % flag to force a particle to spawn
spawn_theta = 'random'; % theta of particle spawn location
spawn_rho = grid_radius; % rho of particle spawn location
if (particles_to_spawn > 0)
    [all_theta(existing_particles+1,1),all_rho(existing_particles+1,1), spawn_error] =SpawnParticle(spawn_theta, spawn_rho, grid_radius,all_theta(:,1), all_rho(:,1));
    if (spawn_error)
        error('t=0 ERROR: Could not spawn particle. [firstspawn routine]');
    end
    existing_particles = existing_particles + 1;
    spawned_particles = spawned_particles + 1;
end
spawn_theta = zeros(num_particles,1);
next_theta(existing_particles) = all_theta(existing_particles,1);
next_rho(existing_particles) = all_rho(existing_particles,1);
%% Particle Transport
%
%
particle_spawn_timer = particle_spawn_time;
for n = 1:t
    % init position for the new timestep
    all_theta(:,n) = next_theta(:);
    all_rho(:,n) = next_rho(:);
    % time saving optimization
    % if all particles are bound, stop time loop
    if (num_bound == num_particles)
        fprintf('All particles bound at %d\n', n)
        t = n;
        break;
    end
    for ii = 1:existing_particles
        % check if the particle is not bound
        if (bound(ii) == 0)
            % current location in cartesian
            [this_loc_x,this_loc_y] =pol2cart(next_theta(ii),next_rho(ii));
            % all particles
            [all_loc_x,all_loc_y] =pol2cart(all_theta(:,n),all_rho(:,n));all_loc_x = all_loc_x(1:existing_particles);
            all_loc_y = all_loc_y(1:existing_particles);
            all_theta_exist =all_theta(1:existing_particles,n);
            all_rho_exist = all_rho(1:existing_particles,n);
            % find all bound particles
            bound_index = find(bound==1);
            bound_loc_x = all_loc_x(bound_index);
            bound_loc_y = all_loc_y(bound_index);
            % if there are any bound particles, check for newbinds
            if (bound_index > 0)
                % if particle is touching another boundparticle, it gets% bound
                if (sum(sqrt(next_rho(bound_index).^2+next_rho(ii)^2-2.*next_rho(bound_index).*next_rho(ii).*cos(next_theta(ii)-next_theta(bound_index))) <= 1.1) > 0 )
                    bound(ii) = 1;
                    %record network connection here
                    
                    num_bound = num_bound + 1;
                    force_particle_spawn =force_particle_spawn + 1;
                    spawn_theta(force_particle_spawn) =next_theta(ii);
                end
            end
            % if current particle is not bound, calculatemovement
            if (bound(ii) == 0)
                if (time_until_hop(ii) == 0)
                    % calculate next move
                    this_loc_x = this_loc_x +diff_vec_x(ii);
                    this_loc_y = this_loc_y +diff_vec_y(ii);
                    [this_theta, this_rho] =cart2pol(this_loc_x,this_loc_y);
                    % if particle moved out of valid area,bring it back in
                    if (this_rho > grid_radius)
                        this_rho = grid_radius;
                        [this_loc_x,this_loc_y] =pol2cart(this_theta,this_rho);
                    end
                    % if the particle is trying to land onanother
                    % particle, walk it back
                    all_rho_exist(ii) = this_rho;
                    all_theta_exist(ii) = this_theta;
                    runaway = 0;
                    if (sum(sqrt(all_rho_exist.^2+this_rho^2-2.*all_rho_exist.*this_rho.*cos(this_theta - all_theta_exist)) < 1) > 1 )
                        this_loc_x = this_loc_x - (0.1 *diff_vec_x(ii));
                        this_loc_y = this_loc_y - (0.1 *diff_vec_y(ii));
                        [this_theta, this_rho] =cart2pol(this_loc_x,this_loc_y);
                        all_rho_exist(ii) = this_rho;
                        all_theta_exist(ii) =this_theta;
                        while (sum(sqrt(all_rho_exist.^2+this_rho^2-2.*all_rho_exist.*this_rho.*cos(this_theta-all_theta_exist)) < 1) > 1 )
                            this_loc_x = this_loc_x -(0.1 * diff_vec_x(ii));
                            this_loc_y = this_loc_y -(0.1 * diff_vec_y(ii));
                            [this_theta, this_rho] =cart2pol(this_loc_x,this_loc_y);
                            all_rho_exist(ii) =this_rho;
                            all_theta_exist(ii) =this_theta;
                            runaway = runaway + 1;
                            if (runaway == (1/.1))
                                fprintf('Warning:Large particle locationadjust\n');
                            end
                        end
                    end
                    next_theta(ii) = this_theta;
                    next_rho(ii) = this_rho;
                    % if particle reaches the cathode,it's automatically bound
                    if (abs(this_rho) < center + .5)
                        bound(ii) = 1;
                        num_bound = num_bound + 1;
                        this_rho = 0;
                        next_theta(ii) = this_theta;
                        next_rho(ii) = this_rho;
                        force_particle_spawn = 1;
                        spawn_theta = this_theta;
                    else
                        % calculate particle motionparameters
                        % DRIFT
                        if (size(bound_index,1) > 0)
                            this_loc_x(1:size(bound_index),1) = this_loc_x;
                            this_loc_y(1:size(bound_index),1) = this_loc_y;
                            % drift direction, fromparticle to each bound location
                            drift_dir_x = bound_loc_x -this_loc_x;
                            drift_dir_y = bound_loc_y -this_loc_y;
                            drift_dir =wrapTo2Pi(atan2(drift_dir_y,drift_dir_x));
                            % slope from bound to ion
                            m = (this_loc_y -bound_loc_y) ./ (this_loc_x -bound_loc_x);
                            % coords of anode
                            edge_x = sign(this_loc_x).* sqrt(grid_radius^2 .* m.^2 +grid_radius^2) ./ (m.^2 + 1); %take the distance from thecathode center (0,0) to theedge_x, solve for edge_x from(edge_y = m * edge_x + b) wherem is between the bound loc andthe ion.
                            edge_y = m .* edge_x;
                            % field direction frombound loc to anode
                            field_dir =wrapTo2Pi(drift_dir + pi);
                            % distance from bound locto anode
                            dist_from_anode =sqrt(bsxfun(@minus,edge_x,bound_loc_x).^2+bsxfun(@minus,edge_y,bound_loc_y).^2);
                        else
                            % drift direction, always
                            towards the center
                            drift_dir_x = center -this_loc_x;
                            drift_dir_y = center -this_loc_y;
                            drift_dir =wrapTo2Pi(atan2(drift_dir_y,drift_dir_x));
                            % distance from potentialsource
                            dist_from_anode =grid_radius;
                        end
                        E = V(n) ./ (lattice_const *dist_from_anode); % E = keQ/r^2,Q=Vr/ke
                        % DIFFUSION
                        diff_pmf = diff_pmf_base;
                        for jj = 1:size(drift_dir,1)
                            % calculate barriermodification weight
                            diff_pmf_barriermod = 1 * ((lattice_const * E(jj) / 2) /(Wa0_eff) ) / size(drift_dir,1);
                            % (aE/2)/(Wa0-kbT) [eV] => %barrier mod
                            [~, drift_dir_index(jj)] =min(abs(move_theta -drift_dir(jj))); % 2nd result ofmin() is the index
                            drift_dir_pi_index(jj) =drift_dir_index(jj) +index_rotate;
                            if (drift_dir_pi_index(jj)> diff_pmf_size)
                                drift_dir_pi_index(jj) = drift_dir_pi_index(jj) -diff_pmf_size;
                            end
                            % enhance diff_pmf indirection of drift and reduce
                            % diff_pmf in the oppositedirection
                            diff_pmf(drift_dir_index(jj)) =diff_pmf(drift_dir_index(jj)) +diff_pmf_base(drift_dir_index(jj)) * diff_pmf_barriermod;
                            diff_pmf(drift_dir_pi_index(jj)) =diff_pmf(drift_dir_pi_index(jj))-diff_pmf_base(drift_dir_pi_index(jj)) * diff_pmf_barriermod;
                            if(diff_pmf(drift_dir_pi_index(jj)) < 0)
                                diff_pmf(drift_dir_pi_index(jj)) = 0;
                            end
                        end
                        % choose a weighted randomdirection for diffusion
                        diff_dir =randsample(move_theta,1,true,diff_pmf);
                        diff_vec_x(ii) = cos(diff_dir);
                        diff_vec_y(ii) = sin(diff_dir);
                        % reset time until next hop
                        time_until_hop(ii) = v;
                    end
                else
                    time_until_hop(ii) =time_until_hop(ii) - 1;
                end
            end
        end
        % update position for the new timestep
        all_theta(ii,n) = next_theta(ii);
        all_rho(ii,n) = next_rho(ii);
    end
    % spawn new particles after updating existing particles
    % only spawn new particles when the timer expires
    if (particle_spawn_timer == 0 || force_particle_spawn > 0)
        % check to see if we've spawned the maximum number of
        % particles already
        for ii = 1:force_particle_spawn
            if (spawned_particles < particles_to_spawn)
                [all_theta(existing_particles+1,n),all_rho(existing_particles+1,n), spawn_error] =SpawnParticle(spawn_theta(ii), spawn_rho,grid_radius, all_theta(:,n), all_rho(:,n));
                if (spawn_error)
                    break;
                end
                existing_particles = existing_particles +1;
                spawned_particles = spawned_particles + 1;
                % existing_particles got incremented
                next_theta(existing_particles) =all_theta(existing_particles,n);
                next_rho(existing_particles) =all_rho(existing_particles,n);
            end
        end
        particle_spawn_timer = particle_spawn_time;
        force_particle_spawn = 0;
    end
    particle_spawn_timer = particle_spawn_timer - 1;
    % Display sim time in command window
    fprintf('Elapsed Time: %d s\n', n)
end
    if (spawn_error)
        error('t=%d ERROR: Could not spawn particle. [particletransport routine]',n)
    end
% sim finished time
time_finish = datestr(now);
fprintf('Sim finished: %s\n', time_finish)


%% Result Plot
%
% set first arg to 1 for final plot only, 2 for particle movie
DrawPlot(1, t, grid_radius, all_theta(:,:), all_rho(:,:));

figure(2)
%axs = axes('XLim',[-50,50],'YLim',[-50,50], 'XLimMode', 'manual', 'YLimMode', 'manual');
scatter(bound_loc_x, bound_loc_y, 1)
xlim([-50,50])
ylim([-50,50])
saveas(1,'FossDendriteFigure.png')
dataToSave = zeros(1001);
for i=1:max(size(bound_loc_x))
    dataToSave(round(bound_loc_x(i)*500/50)+500, round(-bound_loc_y(i)*500/50)+500)=255;
end
figure(3)
imshow(mat2gray(dataToSave'))
imwrite(mat2gray(dataToSave'), 'FossDendrite.png');


%----------------------------------------------------------
% Function:
% SpawnParticle
%----------------------------------------------------------
% Arguments:
% argc = 5
% argv(1) = spawn_theta (scalar)
% argv(2) = spawn_rho (scalar)
% argv(3) = grid_radius (scalar)
% argv(4) = all_theta (1d vector)
% argv(5) = all_rho (1d vector)
%
% Returns:
% return(1) = spawn_theta (scalar)
% return(2) = spawn_rho (scalar)
% return(3) = error (scalar)
%----------------------------------------------------------
% Dependencies:
% None
%----------------------------------------------------------
% Description:
% Spawn particles at a position inside the active region.
%----------------------------------------------------------
function [ spawn_theta, spawn_rho, error ] = SpawnParticle(spawn_theta, spawn_rho, grid_radius, all_theta, all_rho )
valid_start_pos = 0;
timeout = 0;
spawn_mode_theta = spawn_theta;
spawn_mode_rho = spawn_rho;
theta = 0:.01:2*pi;
theta_tol = .1745; % 10 degrees
while (valid_start_pos == 0 && timeout < 1000)
if (spawn_mode_theta == 'random')
spawn_theta =wrapToPi(theta(randi([1,size(theta,2)])));
else
spawn_theta = spawn_theta + (-theta_tol +2*theta_tol*rand);
end
if (spawn_mode_rho == 'random')
spawn_rho = 1+grid_radius*rand;
end
if ( sum(sqrt(all_rho.^2+spawn_rho^2-2.*all_rho.*spawn_rho.*cos(spawn_theta-all_theta)) <= 1) == 0 )
valid_start_pos = 1;
else
timeout = timeout + 1;
end
end
if (timeout < 1000)
error = 0;
else
error = 1;
end
end
%----------------------------------------------------------------
% Function:
% DrawPlot
%----------------------------------------------------------------
% Arguments:
% argc = 4
% argv(1) = plot_type
% argv(2) = t
% argv(3) = thetas
% argv(4) = rhos
%
% Returns:
% None
%----------------------------------------------------------------
% Dependencies:
% None
%----------------------------------------------------------------
% Description:
% Plots results and draws visual candy. If plot_type = 1, showonly end
% result. If plot_type = 2, show particle movie.
%----------------------------------------------------------------
function [ ] = DrawPlot( plot_type, t, radius, thetas, rhos )
% Particle Plot
if (plot_type == 1)
linet = 0:.01:2*pi;
figure(1)
line = polar(linet,radius*ones(size(linet)));
hold on
polar(thetas(:,t),rhos(:,t),'.')
else
numframes = t;
fig1 = figure(1);
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
A = moviein(numframes,fig1,winsize);
set(fig1,'NextPlot','replacechildren')
for j = 1:numframes
%hold on
polar(thetas(:,j),rhos(:,j),'.')
A(:,j) = getframe(fig1,winsize);
end
if (plot_type == 3)
% repeat the plot animation
movie(fig1,A,30,60,winsize)
end
end
end