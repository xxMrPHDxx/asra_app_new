from PIL import Image
import os

w = 64

for file in os.listdir("markers2"):
    if file == 'car.png': continue
    img = Image.open(f'markers2/{file}')
    img1 = img.resize((w,int(154/111*w)))
    # if not os.path.exists('markers2'): os.makedirs('markers2')
    img1.save(f'markers/{file}')
