function x_dec = huffman_dec(y, dict);
	x_dec=[];
	total_length=size(y,2);
	ptr=0;
	while(ptr<total_length)
		for i=1:size(dict,1)
			code=dict{i,2};
			code_len=size(code,2);
			match=true;
			if ptr+code_len>total_length
				continue
			end
			for j=1:size(code,2)
				if y(ptr+j)~=code(j)
					match=false;
					break
				end
			end
			if match
				x_dec=[x_dec, dict{i,1}];
				ptr=ptr+size(code,2);
			break
		end
	end
end
