# 📱 SMS Agent - Guia de Instalação

## ⚠️ IMPORTANTE

Este tweak é **apenas para testes em seu próprio iPhone jailbreakado**.

---

## 📋 Pré-requisitos

1. ✅ iPhone com **Jailbreak** ativo
2. ✅ **Cydia** ou **Sileo** instalado
3. ✅ **OpenSSH** instalado via Cydia
4. ✅ iPhone conectado ao **WiFi**
5. ✅ Saber o **IP do iPhone**

---

## 🚀 Passo 1: Achar o IP do iPhone

### No iPhone:
1. **Settings** → **Wi-Fi**
2. Toque no WiFi conectado (com ✓)
3. Procure por **"IP Address"**
   - Exemplo: `192.168.1.100`

---

## 📦 Passo 2: Preparar o Arquivo .deb

O arquivo estará em:
```
C:\repo\deb_build\
```

Você pode:
- **Opção A:** Transferir diretamente via SSH
- **Opção B:** Usar Cydia/Sileo para instalar

---

## 🔐 Passo 3: Instalar via SSH (RECOMENDADO)

### No seu Windows (PowerShell):

```powershell
# Conectar ao iPhone via SSH
ssh root@192.168.1.100

# Senha padrão: alpine
# (altere depois!)
```

### No iPhone (terminal SSH):

```bash
# Ir para pasta de instalação
cd /var/mobile/Library/

# Receber o arquivo via SCP (em outro terminal Windows)
```

### Voltar ao Windows (novo PowerShell):

```powershell
# Copiar arquivo .deb para iPhone
scp C:\repo\deb_build.deb root@192.168.1.100:/tmp/

# Confirmar SSH novamente
ssh root@192.168.1.100

# Instalar o .deb
dpkg -i /tmp/com.smsagent.tweak_1.0.0_iphoneos-arm64.deb

# Fazer respring
killall -9 SpringBoard
```

---

## Opção B: Usar Cydia/Sileo

1. Copie o arquivo `.deb` para seu iPhone (via iCloud, Dropbox, etc)
2. Abra **Cydia** ou **Sileo**
3. Toque em **"Instalar"** (geralmente canto superior direito)
4. Selecione o arquivo `.deb`
5. Confirme a instalação
6. **Respring** (home + volume up, deslize para cima)

---

## ✅ Usar o Tweak

Após instalar:

1. Abra **Cydia** ou **Sileo**
2. Procure por **"SMS Agent"**
3. Uma nova app deve aparecer na tela inicial
4. **Toque para abrir** a interface

### Na interface:
- Cole números de telefone (um por linha)
- Escreva a mensagem
- Tap em **"Enviar SMS"**
- Confirme cada SMS que aparecer

---

## 🆘 Troubleshooting

### "SSH: Connection refused"
- Verifique se OpenSSH está instalado no Cydia
- Verifique se o IP está correto
- Tente reiniciar o iPhone

### "Senha não funciona"
- Senha padrão é: `alpine`
- Se alterou, use a nova senha

### "Tweak não aparece após instalar"
- Faça **Respring**: home + volume up, deslize para cima
- Ou execute: `killall -9 SpringBoard`

### "Erro ao executar dpkg"
```bash
# Tentar com permissões
sudo dpkg -i /tmp/com.smsagent.tweak_1.0.0_iphoneos-arm64.deb

# Reparar pacotes
sudo dpkg --configure -a
```

---

## ⚠️ Avisos Legais

- **Apenas para testes pessoais**
- SMS em massa não autorizado é **ILEGAL**
- Use apenas com contatos que consentiram
- O criador não se responsabiliza por mau uso

---

## 🔄 Desinstalar

### Via SSH:
```bash
dpkg -r com.smsagent.tweak
```

### Via Cydia/Sileo:
1. Procure por "SMS Agent"
2. Toque em **"Remover"**
3. Confirme

---

**Pronto!** Seu tweak deve estar funcionando! 🎉
