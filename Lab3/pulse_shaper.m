function y = pulse_shaper(x, pulse_shape, W)
    oversampling_factor = 1000;
    T_os = 1/oversampling_factor;
    pulse_duration = 1; % 1 sec
    t_axis = (-pulse_duration/2 : T_os : pulse_duration/2 - T_os);
    T=1/(2*W);
    x=upsample(x, T/T_os);
    pulse=zeros(size(t_axis));
    if strcmp(pulse_shape,'sinc')
        pulse=sinc(t_axis/T);
    elseif strcmp(pulse_shape,'raised cosine')
        beta=0.25;
        for i=1:size(t_axis,2)
            if abs(t_axis)==T/(2*beta);
                pulse(i)=pi/4*sinc(1/(2*beta));
            else
                pulse(i)=sinc(t_axis(i)/T)*cos(pi*beta*t_axis(i)/T)/(1-4*beta^2*t_axis(i)^2/T^2);
            end
        end
    end
    y=conv(x,pulse);
end