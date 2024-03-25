function delim = find_delim(mes_dis)
%PATH_DELIM Determines the operating system
%   This function finds the operating system of the running computer and
%   appropriatley provides the delimitter that matches the native syntax.

    if ismac
        % Code to run on Mac platform
        if mes_dis
            fprintf("Paths setup using MACOS notation\n");
        end
        delim = '/';
    elseif isunix
        % Code to run on Linux platform
        if mes_dis
            fprintf("Paths setup using UNIX notation\n");
        end
        delim = '/';
    elseif ispc
        % Code to run on Windows platform
        if mes_dis
            fprintf("Paths setup using WINDOWS notation\n");
        end
        delim = '\';
    else
        if mes_dis
            fprintf("Platform not supported\n")
        end
    end

end