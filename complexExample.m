% this is a complex PLG use case where multiple unit cells are placed together to form a composite
% object
unitSize = 4;
repSpacing = 160;
cornerSpacing = repSpacing+2*(0.5*unitSize+sqrt(unitSize^2/2));
diameter = 0.5;
originOffset = unitSize+sqrt(unitSize^2/2);
%% make balls
obj = PLG;
obj = set(obj,'resolution',20);
obj = set(obj,'strutDiameter',diameter);
obj = set(obj,'unitSize',[unitSize,unitSize,unitSize]);
obj = set(obj,'origin',[0,0,0]);
obj = defineUnit(obj,{'generalCorner'});
obj = set(obj,'replications',[1,1,1]);
obj = cellReplication(obj);
obj = cleanLattice(obj);

obj1 = translate(obj,0,0,cornerSpacing);
obj2 = translate(obj,cornerSpacing/2,0,cornerSpacing/2);
obj3 = translate(obj,cornerSpacing,0,0);
obj4 = translate(obj,cornerSpacing,0,cornerSpacing);
obj = obj1+obj2+obj3+obj4+obj; % 1 face

obj1 = rotate(obj,0,0,90);
obj2 = translate(obj,0,cornerSpacing,0);
obj3 = translate(obj1,cornerSpacing,0,0);
obj = obj1+obj2+obj3+obj;

obj = cleanLattice(obj);
% plot(obj);
cornerObj = obj;
%% make the straight sections
%along x
obj = PLG;
obj = set(obj,'resolution',20);
obj = set(obj,'strutDiameter',diameter);
obj = set(obj,'unitSize',[unitSize,unitSize,unitSize]);
obj = set(obj,'origin',[originOffset,0,0]);
obj = defineUnit(obj,{'bcc','xRods'});
obj = set(obj,'replications',[repSpacing/unitSize,1,1]);
obj = cellReplication(obj);
obj = cleanLattice(obj);

obj1 = translate(obj,0,0,cornerSpacing);
obj = obj1+obj;
obj1 = translate(obj,0,cornerSpacing,0);
objX = obj1+obj;


% along y rotate x by 90
objY = rotate(objX,0,0,90);
objY = translate(objY,cornerSpacing,0,0);

% along z rotate x by 90
objZ = rotate(objX,0,90,0);
objZ = translate(objZ,0,0,cornerSpacing);
%plot(objX+objY+objZ);


%% make some diagonals
obj = PLG;
obj = set(obj,'resolution',20);
obj = set(obj,'strutDiameter',diameter);
specUnitSize = (sqrt(2*(repSpacing/2)^2)-unitSize*2)/20;
obj = set(obj,'unitSize',[specUnitSize,unitSize,unitSize]);
specialOffset = specUnitSize/2+unitSize/2+sqrt(unitSize^2/2);
obj = set(obj,'origin',[specialOffset,0,0]);
obj = defineUnit(obj,{'bcc','xRods'});
obj = set(obj,'replications',[21,1,1]);
obj = cellReplication(obj);
obj = cleanLattice(obj);
obj1 = rotate(obj,0,-45,0);
obj2 = rotate(obj,0,-45+90,0);
obj3 = rotate(obj,0,-45+180,0);
obj4 = rotate(obj,0,-45+270,0);
obj = translate(obj1+obj2+obj3+obj4,cornerSpacing/2,0,cornerSpacing/2);

diagXZ = obj + translate(obj,0,cornerSpacing,0);
diagYZ = rotate(diagXZ,0,0,90);
diagYZ = translate(diagYZ,cornerSpacing,0,0);
% plot(diagXZ+diagYZ);

%% save out
obj = objX+objY+objZ+cornerObj+diagXZ+diagYZ;
save3mf(obj,'complexLattice');