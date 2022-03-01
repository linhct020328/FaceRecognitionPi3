import base64
from Crypto.Cipher import AES

def encrypt_aes_256(clear_text, key, iv):
    key_byte = key.encode('utf-8')
    key_byte = key_byte.ljust(32, "\0".encode('utf-8'))
    if len(key_byte) > 32:
        key_byte = key_byte[:32]
    iv_byte = iv.encode('utf-8')
    iv_byte = iv_byte.ljust(16, "\0".encode('utf-8'))
    if len(iv_byte) > 16:
        key_byte = key_byte[:16]

    # PKCS#5
    pad_len = 16 - len(clear_text) % 16
    padding = chr(pad_len) * pad_len
    clear_text += padding

    cryptor = AES.new(key_byte, AES.MODE_CBC, iv_byte)
    data = cryptor.encrypt(clear_text)

    return base64.b64encode(data).decode('utf-8')

def decrypt_aes_256(data, key, iv):
    data_byte = base64.b64decode(data.encode('utf-8'))
    key_byte = key.encode('utf-8')
    key_byte = key_byte.ljust(32, "\0".encode('utf-8'))
    if len(key_byte) > 32:
        key_byte = key_byte[:32]
    iv_byte = iv.encode('utf-8')
    iv_byte = iv_byte.ljust(16, "\0".encode('utf-8'))
    if len(iv_byte) > 16:
        key_byte = key_byte[:16]

    cryptor = AES.new(key_byte, AES.MODE_CBC, iv_byte)
    c_text = cryptor.decrypt(data_byte)

    # PKCS#5
    pad_len = ord(c_text.decode('utf-8')[-1])
    clear_text = c_text.decode('utf-8')[:-pad_len]

    return clear_text