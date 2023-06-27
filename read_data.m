function map = read_data(filename)
    
    fileID = fopen(filename,'r');
    formatSpec = '%f, %f';
    sizeA = [2 Inf];
    A = fscanf(fileID, formatSpec, sizeA);
    map = A';
    fclose('all');
   
end

