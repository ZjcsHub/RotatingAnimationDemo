from django.test import TestCase

# Create your tests here.
from cryptography.fernet import Fernet
import base64

def decrypt_api_key(encrypted_key, encryption_key):
    # 创建Fernet实例
    f = Fernet(base64.b64decode(encryption_key))

    # 解密
    encrypted_bytes = base64.b64decode(encrypted_key)
    decrypted_bytes = f.decrypt(encrypted_bytes)

    # 返回解密后的API Key
    return decrypted_bytes.decode()

# 使用示例
encryption_key = "UV9CRGthZjJJQ3lpaUNrX0tEd3BpQ3dHRmt1Q1FGN2lTM0NSYkVyRTNRUT0="
encrypted_api_key = "Z0FBQUFBQm9CY2FWUHFfNjVHN1VxeGZEbF9xTDhyTUFaMzR3RGhINWJhMVVyT0dlUUg5a2t3Mll0azV1TGZkdW1iS0hqUThfSkI5UFhNMF85VllweW12RUl6d05SYzlRR2hmdER3UnV1Z0QwSjNEck5id1EyZFczM1dldzg2QXNRRkxENWt6R3ZwQlM="
api_key = decrypt_api_key(encrypted_api_key, encryption_key)
print(api_key)