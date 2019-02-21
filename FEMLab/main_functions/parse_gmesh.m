function files = parse_gmesh()

tags = {'$MeshFormat', '$PhysicalNames', ...
    '$Nodes', '$Elements'};
parsed_data = struct();

[file_name, file_path] = uigetfile('*.msh', 'Select mesh file');
file_name = strrep(file_name, '.msh', '');
files = generate_files(file_path, file_name);
f_info = read_finfo(files);

if(file_changed(files, f_info))
    
    disp('-Parsing gmesh file ...')
    tic
    
    generate_finfo(files);
    input_file = files.mesh_file;
    fid = fopen(input_file);
    
    is_parsing = 1;
    i_tag = 1;
    n_tags = numel(tags);
    
    [line, err] = get_line(fid);
    if(strcmp(line, tags{i_tag}) && err == 0)
        mesh_format = get_line(fid);
        end_tag = strrep(tags{i_tag}, '$', '$End');
        while(~strcmp(get_line(fid), end_tag))
        end
        i_tag = i_tag + 1;
    end
    
    while(is_parsing)
        line = get_line(fid);
        if(strcmp(line, tags{i_tag}))
            n_items = str2double(get_line(fid));
            val_cell = cell(n_items, 1);
            for i=1:n_items
                val_cell(i) = {get_line(fid)};
            end
            parsed_data(i_tag-1).val_cell = val_cell;
            parsed_data(i_tag-1).n_items = n_items;
            
            end_tag = strrep(tags{i_tag}, '$', '$End');
            while(~strcmp(get_line(fid), end_tag))
            end
        end
        
        i_tag = i_tag + 1;
        if(i_tag > n_tags), is_parsing = 0; end
        
    end
    
    phy_names = parsed_data(1).val_cell; n_regions = parsed_data(1).n_items;
    nodes_cell = parsed_data(2).val_cell; n_nodes = parsed_data(2).n_items;
    elements_cell = parsed_data(3).val_cell; n_elements = parsed_data(3).n_items;
    
    [regions, nodes, elements] = mat2struct(phy_names, n_regions,...
        nodes_cell, n_nodes, elements_cell, n_elements);
    
    reg_vals = {regions.name};
    reg_keys = [regions.tag];
    
    [regparams, regnames] = read_settings(file_path);
    regions_c = Regions(regnames, regparams);
    regions_c = regions_c.set_reg_map(reg_keys, reg_vals);
    
    element_r = reshape([elements.tags], [2, n_elements])';
    element_r(:,2) = [];
    
    [nodes_prop, n_sys] = get_dirichlet_nodes(elements, element_r, n_nodes, regions_c);
    
    fclose(fid);
    
    save(files.respth, 'regions', 'nodes', 'elements',...
        'n_regions', 'n_nodes', 'n_elements', 'element_r', 'regions_c', ...
        'regparams', 'nodes_prop', 'n_sys');
else
    disp('-File not changed since last parse')
    tic
end

disp(['  Finished (Elapsed time : ', num2str(toc) ' s)'])