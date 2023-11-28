function DefWindowSize2Stimulus()
screenSize = get(0,'screensize');

lines  = readlines('stimulus\singleshot_stimulus\testlist\example.txt');
whichline = [9,10];
pat = digitsPattern;
for i = 1:size(whichline,2)
    aline = whichline(i);
    lines(aline) = replace(lines(aline),extract(lines(aline),pat), num2str(screenSize(2+i)));
end
writelines(lines,'stimulus\singleshot_stimulus\testlist\example.txt');

lines  = readlines('stimulus\singleshot_stimulus\setting\setting.txt');
whichline = [4,5];
pat = digitsPattern;
for i = 1:size(whichline,2)
    aline = whichline(i);
    lines(aline) = replace(lines(aline),extract(lines(aline),pat), num2str(screenSize(2+i)));
end
writelines(lines,'stimulus\singleshot_stimulus\setting\setting.txt');

% -----------------------------------------------------------------------------

lines  = readlines('stimulus\singleshot_stimulus\testlist\example.txt');
whichline = [45,55, 63, 64];
numb = [screenSize(3) screenSize(4) screenSize(3) screenSize(4)] - 300;
pat = digitsPattern;
for i = 1:size(whichline,2)
    aline = whichline(i);
    lines(aline) = replace(lines(aline),extract(lines(aline),pat), num2str(numb(i)));
end
writelines(lines,'stimulus\singleshot_stimulus\testlist\example.txt');

end