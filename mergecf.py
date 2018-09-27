import hiyapyco
import sys
import os
import glob

basepath = os.path.dirname(os.path.realpath(__file__))
hiyapyco._usedefaultyamlloader = True
stackname = sys.argv[1]
stacktype = ''
stackpath = ''
if len(sys.argv) > 2:
    stacktype = sys.argv[2]
    stackpath = os.path.join(basepath,'cf',stackname,stacktype)
else:
    stackpath = os.path.join(basepath,'cf',stackname)

stacks = os.path.join(stackpath,'*.yaml')
print(stacks)
conf = hiyapyco.load(glob.glob(stacks), method=hiyapyco.METHOD_MERGE)
# print(hiyapyco.dump(conf))

mergedFile = stackpath
if len(sys.argv) > 2:
    mergedFile = os.path.join(stackpath, stackname+'_'+stacktype+'.yaml')
else:
    mergedFile = os.path.join(mergedFile,stackname+'.yaml')
try:
    os.remove(mergedFile)
except OSError:
    pass
with open(mergedFile, 'w') as yaml_file:
    hiyapyco.dump(conf, stream=yaml_file)
