function folder_path= create_folder(save_folder)
    tmp = convertStringsToChars(save_folder);
    if(tmp(end) ~='/')
        save_folder = save_folder + '/';
    end
    if ~exist(save_folder, 'dir')
           mkdir(save_folder);
    end
    folder_path = save_folder;
end