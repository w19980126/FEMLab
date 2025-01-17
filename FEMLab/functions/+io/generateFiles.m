function files = generateFiles(filePath, fileName, sep)

files = struct();

if(filePath(end) ~= '\' & filePath(end) ~= '/')
    filePath = [filePath, sep];
else
    filePath(end) = sep;
end

files.mesh = [fileName, '.msh'];
files.projectFile = [filePath, fileName, '.mat'];
files.geo = [fileName, '.geo'];
files.fileName = fileName;
files.filePath = filePath;
files.setupPath = [filePath, 'setup_files', sep];
files.mshFile = [filePath, fileName, '.msh'];
files.geoFile = [filePath, fileName, '.geo'];
files.results = [filePath, 'results', sep];
files.finfo = [files.results, 'finfo.mat'];
files.setfile = [filePath, 'settings.mat'];
files.regfile = [filePath, 'regions.txt'];
files.linePoints = [files.setupPath, 'linePoints.txt'];
files.settxtfile = [filePath, 'settings.txt'];
files.respth = [files.results, fileName];
files.pltpth = [filePath, 'plots', sep];
files.pltpthMesh = [files.pltpth, fileName, '_mesh'];
files.pltpthPot = [files.pltpth, fileName, '_potential'];
files.pltpthAbsB = [files.pltpth, fileName, '_absB'];
files.pltpthQuivB = [files.pltpth, fileName, '_quivB'];
files.pltpthContB = [files.pltpth, fileName, '_contB'];
files.pltpthSliceB = [files.pltpth, fileName, '_sliceB'];
files.pltpthAbstriB = [files.pltpth, fileName, '_abstriB'];
files.pltpthFlinesB = [files.pltpth, fileName, '_flinesB'];
files.pltpthAbsE = [files.pltpth, fileName, '_absE'];
files.pltpthQuivE = [files.pltpth, fileName, '_quivE'];
files.pltpthContE = [files.pltpth, fileName, '_contE'];
files.pltpthSliceE = [files.pltpth, fileName, '_sliceE'];
files.pltpthAbstriE = [files.pltpth, fileName, '_abstriE'];
files.pltpthFlinesE = [files.pltpth, fileName, '_flinesE'];
files.pltpthAbsA = [files.pltpth, fileName, '_absA'];
files.pltpthQuivA = [files.pltpth, fileName, '_quivA'];
files.pltpthContA = [files.pltpth, fileName, '_contA'];
files.pltpthAbstriA = [files.pltpth, fileName, '_abstriA'];
files.pltpth_valid1 = [files.pltpth, fileName, '_validation_comp'];
files.pltpth_valid2 = [files.pltpth, fileName, '_validation_error'];
files.filesModified = true;
files.regionsReady = false;

if(exist(files.pltpth, 'dir') ~= 7)
    mkdir(files.pltpth)
end

if(exist(files.results, 'dir') ~= 7)
    mkdir(files.results)
end

if(exist(files.setupPath, 'dir') ~= 7)
    mkdir(files.setupPath)
end

if(exist([files.respth, '.mat'], 'file') ~= 2)
    save(files.respth, 'fileName')
end

if(exist(files.projectFile, 'file') ~= 2)
    save(files.projectFile, 'fileName')
end

if(exist(files.linePoints, 'file') ~= 2)
    io.generateLinePointsFile(files.linePoints)
end