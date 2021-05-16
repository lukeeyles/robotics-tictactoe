classdef GameTile < handle
    properties
        filename;
        T; % transform
        h; % handle to plot object
    end
    
    methods
        function self = GameTile(filename,T)
            self.filename = filename;
            self.T = T;
        end
        
        function Plot(self,T)
            if ~exist('T','var')
                T = self.T;
            else
                self.T = T;
            end
            delete(self.h);
            self.h = plotply(self.filename,T);
        end
    end
end

