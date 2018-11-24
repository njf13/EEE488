classdef TransmissionLineSegmentClass
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Vin=0;
        Iin=0;
        Vout=0;
        Iout=0;
        deltat=1
        deltaz=1
        R=1
        L=1
        G=1
        C=1
    end
    
    methods
        function obj = TransmissionLineSegmentClass(deltat, deltaz, R, L, G, C)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.R = R;
            obj.L = L;
            obj.G = G;
            obj.C = C;
            obj.deltat = deltat;
            obj.deltaz = deltaz;
        end
        
        function [Vfinal, Ifinal] = DriveSegment(obj, Vapplied, Iapplied)
            %DriveSegment - Drives the transmission line segment with specified
            %inputs.
            
            Vouttemp = Vapplied - obj.R*Iapplied - obj.L*(Iapplied - obj.Iin);
            obj.Iout = Iapplied - obj.G*obj.Vout - obj.C*(Vouttemp - obj.Vout);
            
            obj.Vout = Vouttemp;
            Vfinal=obj.Vout;
            Ifinal=obj.Iout;
        end
    end
end

