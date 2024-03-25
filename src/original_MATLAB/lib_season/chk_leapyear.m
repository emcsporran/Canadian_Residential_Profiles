function chk_bool = chk_leapyear(year_in)
%CHK_LEAPYEAR there is another function called leapyear that requires
%the Aerospace toolbox but this works as well.

   if (rem(year_in, 400) == 0) || (rem(year_in, 100) ~= 1) && ...
           (rem(year_in, 4) == 0)
       chk_bool = 1;
   else
       chk_bool = 0;
   end

end