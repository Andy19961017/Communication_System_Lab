function symbol_sequence = symbol_mapper(binary_sequence, M, d, constellation, mapping)
    % error checking
    if constellation == 'PAM' | constellation == 'PSK';
        if M~=2 & M~=4 & M~=8 & M~=16;
            error('Invalid value for M');
        end
    elseif constellation == 'QAM';
        if M~=4 & M~=16;
            error('Invalid value for M');
        end
    end
    
    numOfBits=int8(log2(M));
    symbol_sequence=[];
    if mod(size(binary_sequence,2),numOfBits)~=0
        binary_sequence=[binary_sequence, zeros(1,numOfBits-mod(size(binary_sequence,2),numOfBits))]; %appending
    end
    
    while(size(binary_sequence,2)>0);
        num=0;
        for i=1:numOfBits;
            num=num*2+binary_sequence(i);
        end
        symbol_sequence=[symbol_sequence, num];
        binary_sequence=binary_sequence(double(numOfBits)+1:end);
    end
    
    dict=[];
    if strcmp(constellation,'PAM');
        if strcmp(mapping, 'Binary');
            if M==2;
                dict=py.dict(pyargs('0',-0.5,'1',0.5));
            elseif M==4;
                dict=py.dict(pyargs('0',-1.5,'1',-0.5,'2',0.5,'3',1.5));
            elseif M==8;
                dict=py.dict(pyargs('0',-3.5,'1',-2.5,'2',-1.5,'3',-0.5,'4',0.5,'5',1.5,'6',2.5,'7',3.5));
            elseif M==16;
                dict=py.dict(pyargs('0',-7.5,'1',-6.5,'2',-5.5,'3',-4.5,'4',-3.5,'5',-2.5,'6',-1.5,'7',-0.5,'8',0.5,'9',1.5,'10',2.5,'11',3.5,'12',4.5,'13',5.5,'14',6.5,'15',7.5));
            end
        elseif strcmp(mapping,'Gray');
            if M==2;
                dict=py.dict(pyargs('0',-0.5,'1',0.5));
            elseif M==4;
                dict=py.dict(pyargs('0',-1.5,'1',-0.5,'3',0.5,'2',1.5));
            elseif M==8;
                dict=py.dict(pyargs('0',-3.5,'1',-2.5,'3',-1.5,'2',-0.5,'6',0.5,'7',1.5,'5',2.5,'4',3.5));
            elseif M==16;
                dict=py.dict(pyargs('7',-7.5,'6',-6.5,'4',-5.5,'5',-4.5,'1',-3.5,'0',-2.5,'2',-1.5,'3',-0.5,'11',0.5,'10',1.5,'8',2.5,'9',3.5,'13',4.5,'12',5.5,'14',6.5,'15',7.5));
            end
        end
    elseif strcmp(constellation,'PSK');
        if strcmp(mapping,'Binary');
            if M==2;
                dict=py.dict(pyargs('0',-0.5,'1',0.5));
            elseif M==4;
                dict=py.dict(pyargs('0',-0.5+0.5i,'1',0.5+0.5i,'2',-0.5-0.5i,'3',0.5-0.5i));
            elseif M==8;
                theta=2*pi/8;
                arc=(2-2*cos(theta))^0.5;
                rho=1/arc;
                dict=py.dict(pyargs('0',rho*exp(j*0*theta),'1',rho*exp(j*1*theta),'2',rho*exp(j*2*theta),'3',rho*exp(j*3*theta),'4',rho*exp(j*4*theta),'5',rho*exp(j*5*theta),'6',rho*exp(j*6*theta),'7',rho*exp(j*7*theta)));
            elseif M==16;
                theta=2*pi/16;
                arc=(2-2*cos(theta))^0.5;
                rho=1/arc;
                dict=py.dict(pyargs('0',rho*exp(j*0*theta),'1',rho*exp(j*1*theta),'2',rho*exp(j*2*theta),'3',rho*exp(j*3*theta),'4',rho*exp(j*4*theta),'5',rho*exp(j*5*theta),'6',rho*exp(j*6*theta),'7',rho*exp(j*7*theta),'8',rho*exp(j*8*theta),'9',rho*exp(j*9*theta),'10',rho*exp(j*10*theta),'11',rho*exp(j*11*theta),'12',rho*exp(j*12*theta),'13',rho*exp(j*13*theta),'14',rho*exp(j*14*theta),'15',rho*exp(j*15*theta)));
            end
        elseif strcmp(mapping,'Gray');
            if M==2;
                dict=py.dict(pyargs('0',-0.5,'1',0.5));
            elseif M==4;
                dict=py.dict(pyargs('1',-0.5+0.5i,'3',0.5+0.5i,'0',-0.5-0.5i,'2',0.5-0.5i));
            elseif M==8;
                theta=2*pi/8;
                arc=(2-2*cos(theta))^0.5;
                rho=1/arc;
                dict=py.dict(pyargs('7',rho*exp(j*0*theta),'6',rho*exp(j*1*theta),'2',rho*exp(j*2*theta),'3',rho*exp(j*3*theta),'1',rho*exp(j*4*theta),'0',rho*exp(j*5*theta),'4',rho*exp(j*6*theta),'5',rho*exp(j*7*theta)));
            elseif M==16;
                theta=2*pi/16;
                arc=(2-2*cos(theta))^0.5;
                rho=1/arc;
                dict=py.dict(pyargs('0',rho*exp(j*0*theta),'1',rho*exp(j*1*theta),'3',rho*exp(j*2*theta),'2',rho*exp(j*3*theta),'6',rho*exp(j*4*theta),'7',rho*exp(j*5*theta),'5',rho*exp(j*6*theta),'4',rho*exp(j*7*theta),'12',rho*exp(j*8*theta),'13',rho*exp(j*9*theta),'15',rho*exp(j*10*theta),'14',rho*exp(j*11*theta),'10',rho*exp(j*12*theta),'11',rho*exp(j*13*theta),'9',rho*exp(j*14*theta),'8',rho*exp(j*15*theta)));
            end
        end
    elseif strcmp(constellation,'QAM');
        if strcmp(mapping,'Binary');
            if M==4;
                dict=py.dict(pyargs('0',-0.5+0.5i,'1',0.5+0.5i,'2',-0.5-0.5i,'3',0.5-0.5i));
            elseif M==16;
                dict=py.dict(pyargs('0',-1.5+1.5i,'1',-0.5+1.5i,'2',0.5+1.5i,'3',1.5+1.5i,'4',-1.5+0.5i,'5',-0.5+0.5i,'6',0.5+0.5i,'7',1.5+0.5i,'8',-1.5-0.5i,'9',-0.5-0.5i,'10',0.5-0.5i,'11',1.5-0.5i,'12',-1.5-1.5i,'13',-0.5-1.5i,'14',0.5-1.5i,'15',1.5-1.5i));
            end
        elseif strcmp(mapping,'Gray');
            if M==4;
                dict=py.dict(pyargs('1',-0.5+0.5i,'3',0.5+0.5i,'0',-0.5-0.5i,'2',0.5-0.5i));
            elseif M==16;
                dict=py.dict(pyargs('2',-1.5+1.5i,'6',-0.5+1.5i,'14',0.5+1.5i,'10',1.5+1.5i,'3',-1.5+0.5i,'7',-0.5+0.5i,'15',0.5+0.5i,'11',1.5+0.5i,'1',-1.5-0.5i,'5',-0.5-0.5i,'13',0.5-0.5i,'9',1.5-0.5i,'0',-1.5-1.5i,'4',-0.5-1.5i,'12',0.5-1.5i,'8',1.5-1.5i));
            end
        end
    end
    
    for i=1:size(symbol_sequence,2);
        symbol_sequence(i)=complex(dict{num2str(symbol_sequence(i))})*d;
    end         
end