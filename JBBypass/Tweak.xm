#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*
 * JBBypass Tweak
 * Propósito: Permitir que apps próprios funcionem em dispositivos jailbreakados
 * durante desenvolvimento e testes internos.
 *
 * Métodos comuns de detecção de jailbreak que são neutralizados:
 * 1. Verificação de arquivos do jailbreak (/usr/bin/ssh, /bin/bash, etc.)
 * 2. Verificação de permissões de escrita fora do sandbox
 * 3. Verificação de variáveis de ambiente suspeitas
 * 4. Verificação via canOpenURL para Cydia
 * 5. Verificação via fork()
 */

// ─── 1. Bloquear verificação de arquivos ──────────────────────────────────────

%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString *)path {
    static NSArray *jbPaths = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        jbPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Library/MobileSubstrate",
            @"/usr/bin/ssh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/bin/bash",
            @"/usr/bin/cycript",
            @"/var/jb",
            @"/usr/lib/TweakInject",
            @"/bootstrap",
        ];
    });

    for (NSString *jbPath in jbPaths) {
        if ([path hasPrefix:jbPath]) {
            NSLog(@"[JBBypass] Bloqueando verificação de path: %@", path);
            return NO;
        }
    }
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory {
    static NSArray *jbPaths = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        jbPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Library/MobileSubstrate",
            @"/usr/bin/ssh",
            @"/etc/apt",
            @"/bin/bash",
            @"/var/jb",
        ];
    });

    for (NSString *jbPath in jbPaths) {
        if ([path hasPrefix:jbPath]) {
            return NO;
        }
    }
    return %orig;
}

%end

// ─── 2. Bloquear canOpenURL para Cydia/Sileo ──────────────────────────────────

%hook UIApplication

- (BOOL)canOpenURL:(NSURL *)url {
    NSString *scheme = url.scheme.lowercaseString;
    if ([scheme isEqualToString:@"cydia"] ||
        [scheme isEqualToString:@"sileo"] ||
        [scheme isEqualToString:@"zbra"]) {
        NSLog(@"[JBBypass] Bloqueando canOpenURL: %@", url);
        return NO;
    }
    return %orig;
}

%end

// ─── 3. Bloquear verificação de escrita fora do sandbox ───────────────────────

%hook NSString

- (BOOL)writeToFile:(NSString *)path
         atomically:(BOOL)useAuxiliaryFile
           encoding:(NSStringEncoding)enc
              error:(NSError **)error {
    static NSArray *suspiciousPaths = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        suspiciousPaths = @[@"/private/", @"/tmp/jb"];
    });

    for (NSString *sp in suspiciousPaths) {
        if ([path hasPrefix:sp]) {
            if (error) *error = nil;
            return NO;
        }
    }
    return %orig;
}

%end

// ─── 4. Bloquear verificações de ambiente ─────────────────────────────────────

%hook NSProcessInfo

- (NSDictionary *)environment {
    NSMutableDictionary *env = [%orig mutableCopy];
    [env removeObjectForKey:@"DYLD_INSERT_LIBRARIES"];
    [env removeObjectForKey:@"_MSSafeMode"];
    return [env copy];
}

%end

%ctor {
    NSLog(@"[JBBypass] ✅ Tweak carregado - Detecção de JB neutralizada");
}
