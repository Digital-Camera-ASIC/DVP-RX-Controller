from PIL import Image
import numpy as np

def rgb565_to_rgb888(pixel):
    r = ((pixel >> 11) & 0x1F) * 255 // 31
    g = ((pixel >> 5) & 0x3F) * 255 // 63
    b = (pixel & 0x1F) * 255 // 31
    return (r, g, b)

def read_format_file(format_file):
    with open(format_file, 'r') as file:
        lines = file.readlines()
    
    size_line = lines[0].strip().split('\t')[-1]
    format_line = lines[1].strip().split('\t')[-1]
    
    width, height = map(int, size_line.split(' x '))
    pixel_format = format_line
    
    return width, height, pixel_format

def txt_to_img_with_format(txt_file, img_file, format_file):
    width, height, pixel_format = read_format_file(format_file)
    
    with open(txt_file, 'r') as file:
        lines = file.readlines()[3:]
    
    if pixel_format == 'RGB565':
        pixels = [rgb565_to_rgb888(int(line[i:i+4], 16)) 
          for line in lines 
          for i in range(len(line.strip()) - 4, -4, -4)]

        pixel_array = np.array(pixels, dtype=np.uint8).reshape((height, width, 3))
        img = Image.fromarray(pixel_array, 'RGB')
    elif pixel_format == 'GRAYSCALE':
        pixels = [int(line[i:i+2], 16) for line in lines for i in range(len(line.strip()) - 2, -2, -2)]
        pixel_array = np.array(pixels, dtype=np.uint8).reshape((height, width))
        img = Image.fromarray(pixel_array, 'L')
    else:
        raise ValueError("Unsupported pixel format.")
    
    img.save(img_file)

# Example usage
txt_to_img_with_format('env/axi_mem_data.txt', 'output.png', 'env/axi_mem_format.txt')