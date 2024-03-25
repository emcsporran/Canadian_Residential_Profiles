function matrix2 = matrix_comb_energy(matrix1,vector2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dim1 = size(matrix1);
    dim2 = size(vector2);

    if dim1(1) > dim2(1)

        dif = dim1(1) - dim2(1);

        submat = [vector2; zeros(dif,dim2(2))];
        matrix2 = [matrix1, submat];

    elseif dim2(1) > dim1(1)

        dif = dim2(1) - dim1(1);

        submat = [matrix1; zeros(dif,dim1(2))];
        matrix2 = [submat, vector2];

    else

        matrix2 = [matrix1,vector2];

    end

end