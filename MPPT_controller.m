classdef MPPT_controller < handle
    
    properties
        v_prev
        i_prev
        v_rif
        dPdv_prev
        c
    end
    
    methods
        function obj = MPPT_controller(v_rif, i_prev, v0, c)
            obj.c = c;
            obj.v_prev = v0;
            obj.i_prev = i_prev;
            obj.v_rif = v_rif;
            obj.dPdv_prev = 0;
        end
        
        function d = step(obj, v_curr, v_out, map, i_curr)
           
            dPdv = obj.deriv(v_curr, map, i_curr);
            if (dPdv * obj.dPdv_prev) > 0
                if  dPdv > 0
                    obj.v_rif = obj.v_rif + obj.c;
                else
                    obj.v_rif = obj.v_rif - obj.c;
                end
            end
            
            d = 1- obj.v_rif/v_out;
            obj.v_prev = v_curr;
            obj.dPdv_prev = dPdv;
            obj.i_prev = i_curr;
        end
        
        
        function dPdv = deriv(obj, v_curr, map, i_curr)
%             P_curr = v_curr * interpolate(map, v_curr);
%             P_prev = obj.v_prev * interpolate(map, obj.v_prev);
%             dPdv = (P_curr - P_prev)/(v_curr - obj.v_prev);
              P_curr = v_curr * i_curr;
              P_prev = obj.v_prev * obj.i_prev;
              dPdv = (P_curr - P_prev)/(v_curr - obj.v_prev);
        end
        
    end
end

