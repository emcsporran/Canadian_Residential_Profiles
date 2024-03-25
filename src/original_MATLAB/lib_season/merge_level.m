function man_main = merge_level(man_main,man_hous,dates,name)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    seas = dates.seas.name_short;
    fiel = dates.fiel;


    for i = 1:length(seas)
        comb = matrix_comb_energy(man_hous.(seas(i)).dail_wee,man_hous.(seas(i)).dail_non);
        if sum(man_main.(seas(i)).num) == 0
            man_main.(seas(i)).num = man_hous.(seas(i)).num;
            man_main.(seas(i)).name = name;
            man_main.(seas(i)).dail_non = man_hous.(seas(i)).dail_non;
            man_main.(seas(i)).dail_wee = man_hous.(seas(i)).dail_wee;
            man_main.(seas(i)).comb = comb;
        else
            man_main.(seas(i)).num = [man_main.(seas(i)).num; man_hous.(seas(i)).num];
            man_main.(seas(i)).name = [man_main.(seas(i)).name, name];
            man_main.(seas(i)).dail_wee = matrix_comb_energy(man_main.(seas(i)).dail_wee, man_hous.(seas(i)).dail_wee);
            man_main.(seas(i)).dail_non = matrix_comb_energy(man_main.(seas(i)).dail_non, man_hous.(seas(i)).dail_non);
            man_main.(seas(i)).comb = matrix_comb_energy(man_main.(seas(i)).comb, comb);

        end
        for j = 1:length(fiel)
        
            if sum(sum(man_main.(seas(i)).(fiel(j)))) == 0

                man_main.(seas(i)).(fiel(j)) = man_hous.(seas(i)).(fiel(j));

            else

                man_main.(seas(i)).(fiel(j)) = (man_main.(seas(i)).(fiel(j)) + man_hous.(seas(i)).(fiel(j)))/2;
                
            end

        end
    end

end