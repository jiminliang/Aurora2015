function n = findDay(dayArray, day)
n = [];
i = 1;
while i <= size(dayArray,1)
    index = strfind(dayArray(i,:), day);
    if ~isempty(index)
        n = i;
        break;
    end
    i = i+1;
end