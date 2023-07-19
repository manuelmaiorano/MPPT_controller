classdef MPPT_controller < handle
    
    properties
        v_prev
        i_prev
        v_rif
        dPdv_prev
        c
        csi
        df
    end
    
    methods
        function obj = MPPT_controller(v_rif, i_prev, v0, c, df)
            obj.c = c;
            obj.v_prev = v0;
            obj.i_prev = i_prev;
            obj.v_rif = v_rif;
            obj.dPdv_prev = 0;
            obj.csi = 0;
            obj.df = df;
        end
        
        function [vrif, d] = step(obj, v_curr, v_out, i_curr)
           
            dPdv = obj.deriv(v_curr, i_curr);
            
            %aggiornamento della tensione di riferimeto
            if (dPdv * obj.dPdv_prev) > 0
                if  dPdv > 0
                    obj.v_rif = obj.v_rif + obj.c;
                else
                    obj.v_rif = obj.v_rif - obj.c;
                end
            end
            
            %calcolo di d a partire dal riferimeto e dalla tensione in
            %uscita
            d = 1- obj.v_rif/v_out;
            
%             e = obj.v_rif - v_curr;
%             kp = 0.0005; ki=0.0001; h = 5e-7;
%             obj.csi = obj.csi + h * e;
%             d = obj.df + kp * e + ki * obj.csi; 
            vrif = obj.v_rif;
            
            obj.v_prev = v_curr;
            obj.dPdv_prev = dPdv;
            obj.i_prev = i_curr;
        end
        
        
        function dPdv = deriv(obj, v_curr, i_curr)
          %calcolo derivata
          P_curr = v_curr * i_curr;
          P_prev = obj.v_prev * obj.i_prev;
          dPdv = (P_curr - P_prev)/(v_curr - obj.v_prev);
        end
        
    end
end

