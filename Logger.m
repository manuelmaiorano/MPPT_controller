classdef Logger < handle
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        z
        w
        u
        i
        sig
        port
        t
        x
        idxz
        idxw
        idxu
        idxsig
        idxport
        idxi
        idxt
        idxx
    end
    
    methods
        function obj = Logger(nu, nw, nq)
            %UNTITLED8 Construct an instance of this class
            %   Detailed explanation goes here
            N = 100000;
            obj.z = zeros([nw, N]);obj.idxz = 1;
            obj.w = zeros([nw, N]);obj.idxw = 1;
            obj.u = zeros([nu, N]);obj.idxu = 1;
            obj.sig = zeros([nq, N]);obj.idxsig = 1;
            obj.port = zeros([1, N]);obj.idxport = 1;
            obj.i = zeros([2, N]);obj.idxi = 1;
            obj.t = zeros([1, N]);obj.idxt = 1;
            obj.x = zeros([6, N]);obj.idxx = 1;
        end
        
        function add_t(obj,t)
            obj.t(:, obj.idxt) = t;
            obj.idxt = obj.idxt + 1;
        end
        function add_w(obj,w)
            obj.w(:, obj.idxw) = w;
            obj.idxw = obj.idxw + 1;
        end
        function add_z(obj,z)
            obj.z(:, obj.idxz) = z;
            obj.idxz = obj.idxz + 1;
        end
        function add_sig(obj,sig)
            obj.sig(:, obj.idxsig) = sig;
            obj.idxsig = obj.idxsig + 1;
        end
        function add_port(obj,port)
            obj.port(:, obj.idxport) = port;
            obj.idxport = obj.idxport + 1;
        end
        function add_i(obj,i)
            obj.i(:, obj.idxi) = i;
            obj.idxi = obj.idxi + 1;
        end
        function add_x(obj,x)
            obj.x(:, obj.idxx) = x;
            obj.idxx = obj.idxx + 1;
        end
        
        function plot(obj)
            ts = obj.t(1, 1:obj.idxt-1);
            figure;
            plot(ts, obj.sig(1, 1:obj.idxsig-1));
            figure;
            plot(ts, obj.sig(2, 1:obj.idxsig-1));
            figure;
            plot(ts, obj.port(1, 1:obj.idxport-1));
            figure;
            plot(ts, obj.z(:, 1:obj.idxz-1));
            figure;
            plot(ts, obj.i(:, 1:obj.idxi-1));
            figure;
            plot(ts, obj.x(:, 1:obj.idxx-1));
        end
    end
end

