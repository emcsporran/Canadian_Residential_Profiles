function manual_temp = setupman(seas,fiel)
%     manual_temp.placeholder = 0;

    for i = 1:length(seas)
        for j = 1:length(fiel)
            manual_temp.(seas(i)).(fiel(j)) = zeros(1440,2);
            manual_temp.(seas(i)).(fiel(j)) = zeros(1440,2);
            manual_temp.(seas(i)).num = [0,0];
            manual_temp.(seas(i)).dail_non = [0,0];
            manual_temp.(seas(i)).dail_wee = [0,0];
            manual_temp.(seas(i)).name = "";
        end
    end

end