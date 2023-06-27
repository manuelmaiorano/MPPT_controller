function save_data(filename, v, i)

    fileID = fopen(filename,'w');
    formatSpec = '%f, %f\n';
    fprintf(fileID, formatSpec, [v; i]);
    fclose('all');
end

