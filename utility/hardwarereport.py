#!/usr/bin/env python

import platform


def get_processors():
    p_str = platform.processor()
    
    if platform.system() == 'Linux':
        with open('/proc/cpuinfo') as f:
            for line in f:
                if line.strip():
                    if line.rstrip('\n').startswith('model name'):
                        model_name = line.rstrip('\n').split(':')[1]
                        p_str = p_str +  model_name
                        return p_str
    return p_str

def report_platform(rhome):
    print '>> Platform'
    #TODO: more detail platform descriptions
    print 'Processor:', get_processors()
    print 'OS:',platform.platform()
    print 'R Platform:',rhome