function y = voronoi(obj)
            obj.plot;
            hold
            voronoi(obj.X, obj.Y);
end