def FlagsForFile( filename, **kwargs ):
  return {
          'flags': [ '-x', 'c++', '-Wall', '-Wextra', '-Werror', '-Wnon-gcc', '-std=c++14', 
              # '-I', "C:\\Users\Maxime\\AppData\\Local\\lxss\\rootfs\\usr\\include\\c++\\5",
              # '-I', "C:\\Users\\Maxime\\AppData\\Local\\lxss\\rootfs\\usr\\include\\x86_64-linux-gnu\\c++\\5"
              ], 
         }
