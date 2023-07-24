function q = pwm(value, t, Ts, Vp)
    %portante
    portante = Vp*(sawtooth(2*pi*1/Ts*t) + 1)/2;
    
    if(value < portante)
        q = 0;
    else   
        q = 1;
    end
end

