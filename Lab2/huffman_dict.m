function dict = huffman_dict(symbols, p);
    tree={};
    %initialize huffman tree
    for i=1:size(symbols,2);
        tree{i,2}=p(i); %prob
        tree{i,1}={{symbols(i), []}};  %list of {symbol, code}s
    end
    
    %merge step-by-step
    while size(tree,1)>1;
        %sort according to probability
        [temp, idx] = sort(cell2mat(tree(:,2)));
        tree = tree(idx,:);
        
        %add bit to each code
        for i=1:size(tree{1,1},2);
            tree{1,1}{i}{2}=[1,tree{1,1}{i}{2}];
        end
        for i=1:size(tree{2,1},2);
            tree{2,1}{i}{2}=[0,tree{2,1}{i}{2}];
        end
        
        %merge two leaves
        tree{2,1}=[tree{1,1},tree{2,1}];
        tree{2,2}=tree{1,2}+tree{2,2};
        tree(1,:)=[];
    end
    
    %map to order in 'symbols'
    dict={};
    for i=1:size(symbols,2);
        dict{i,1}=symbols(i);
        for j=1:size(symbols,2);
            if tree{1}{j}{1}==symbols(i);
                dict{i,2}=tree{1}{j}{2};
            end
        end
    end
    
    %display
    display=false;
    if display;
        disp('=====dict=====');
        for i=1:size(dict,1);
            disp('symbol:');
            disp(dict{i,1});
            disp('code:');
            disp(dict{i,2});
            disp('------');
        end
    end
end