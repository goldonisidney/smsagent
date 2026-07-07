#!/bin/bash

echo "🔧 SMS Agent - Compilador Automático"
echo "======================================"

# 1. Verificar THEOS
if [ -z "$THEOS" ]; then
    echo "📦 Setando THEOS..."
    export THEOS=~/theos
fi

# 2. Verificar se THEOS existe
if [ ! -d "$THEOS" ]; then
    echo "❌ THEOS não encontrado em $THEOS"
    echo "Instalando THEOS..."
    git clone --recursive https://github.com/theos/theos.git ~/theos
    export THEOS=~/theos
fi

echo "✅ THEOS: $THEOS"

# 3. Baixar SDK
echo "📥 Verificando iOS SDK..."
if [ ! -d "$THEOS/sdks/iPhoneOS15.8.3.sdk" ]; then
    echo "Baixando iOS 15.8.3 SDK..."
    mkdir -p $THEOS/sdks
    cd $THEOS/sdks

    # Tentar múltiplos links
    wget -q https://github.com/theos/sdks/releases/download/iPhoneOS15.8.3-SDK/iPhoneOS15.8.3.sdk.tar.lz -O sdk.tar.lz 2>/dev/null || \
    wget -q https://github.com/xybp888/iOS-SDKs/releases/download/15.8.3/iPhoneOS15.8.3.sdk.tar.gz -O sdk.tar.gz 2>/dev/null || \
    echo "⚠️ Não conseguiu baixar SDK automáticamente"

    # Descompactar
    if [ -f sdk.tar.lz ]; then
        tar -xf sdk.tar.lz
        rm sdk.tar.lz
    elif [ -f sdk.tar.gz ]; then
        tar -xzf sdk.tar.gz
        rm sdk.tar.gz
    fi
fi

# 4. Compilar
echo ""
echo "🔨 Compilando SMS Agent..."
cd /mnt/c/repo

export THEOS=~/theos
make clean 2>&1 | grep -v "^$"
echo ""
make 2>&1 | tail -30

# 5. Verificar resultado
if [ -f "packages/com.smsagent.tweak_1.0.0_iphoneos-arm64.deb" ]; then
    echo ""
    echo "✅ ✅ ✅ SUCESSO! ✅ ✅ ✅"
    echo ""
    echo "📦 Arquivo gerado:"
    ls -lh packages/com.smsagent.tweak_1.0.0_iphoneos-arm64.deb
    echo ""
    echo "Próximo passo: Instalar no iPhone"
    echo "make install"
else
    echo ""
    echo "❌ Compilação falhou"
    echo "Verifique os erros acima"
fi
