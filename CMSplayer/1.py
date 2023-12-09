import os
import re
import json
import datetime
import requests
from urllib.parse import urlparse

input_directory = r"H:\py\处理前"  # 请替换为实际的输入目录路径
output_directory = r"H:\py\处理后"  # 请替换为实际的输出目录路径
enable_proxy_check = True  # 设为False以禁用代理检测
timeout_duration = 5  # 设置超时时间，默认为5秒
unreachable_text = "无法访问"  # 指定不能访问的链接时的文本
generate_domain_rules = True  # 生成所有链接域名规则的开关
generate_direct_rules = True  # 生成DIRECT规则的开关
direct_rule_content = "DIRECT"  # 自定义DIRECT规则的内容
domain_rule_content = "DOMAIN-SUFFIX"  # 自定义DOMAIN规则的内容

def convert_to_json(text):
    entries = re.findall(r'(.+?)\s+(https?://.+?)(?:\s+|$)', text)
    result = []

    for name, api in entries:
        note = "需要代理" if "需要代理" in name else ""
        name = re.sub(r'\s*\d+\s*', '', name)  # 去除可能的数字
        result.append({
            "name": name.strip(),
            "api": api.strip(),
            "note": note
        })

    return result

def is_proxy_required(api_url):
    try:
        response = requests.get(api_url, timeout=timeout_duration)
        return not response.ok
    except requests.RequestException:
        return True

def process_file(input_file, output_dir, processed_links):
    with open(input_file, 'r', encoding='utf-8') as file:
        content = file.read()

    json_result = convert_to_json(content)
    
    # 生成输出文件名，防止重复
    output_base = os.path.join(output_dir, '测试')
    output_file = output_base + '.txt'
    count = 1
    while os.path.exists(output_file):
        output_file = f"{output_base}{count}.txt"
        count += 1

    unique_links = set()  # 用于保存已处理的链接
    domain_set = set()  # 用于保存所有链接的域名

    for entry in json_result:
        api = entry["api"]
        if api not in unique_links and api not in processed_links:
            unique_links.add(api)
            processed_links.add(api)

            if enable_proxy_check:
                proxy_required = is_proxy_required(api)
                entry["note"] = "需要代理" if proxy_required else unreachable_text

            # 提取域名并添加到域名集合中
            domain = urlparse(api).hostname
            if domain:
                domain_set.add(domain)

    with open(output_file, 'w', encoding='utf-8') as output:
        formatted_json = json.dumps(json_result, ensure_ascii=False, indent=4)
        output.write(formatted_json)

    log_message = f"{datetime.datetime.now()} - Processed file: {input_file} and saved result to {output_file}"
    print(log_message)

    log_file = os.path.join(output_dir, 'log.txt')
    with open(log_file, 'a', encoding='utf-8') as log:
        log.write(log_message + "\n")

    # 生成域名规则文件
    if generate_domain_rules:
        domain_rules_file = os.path.join(output_dir, 'dom.txt')
        count = 1
        while os.path.exists(domain_rules_file):
            domain_rules_file = f"{os.path.join(output_dir, 'dom')}{count}.txt"
            count += 1
        with open(domain_rules_file, 'w', encoding='utf-8') as domain_file:
            for domain in domain_set:
                domain_file.write(f"{domain_rule_content},{domain},{direct_rule_content}\n")

    # 生成DIRECT规则文件
    if generate_direct_rules:
        direct_rules_file = os.path.join(output_dir, 'direct.txt')
        count = 1
        while os.path.exists(direct_rules_file):
            direct_rules_file = f"{os.path.join(output_dir, 'direct')}{count}.txt"
            count += 1
        with open(direct_rules_file, 'w', encoding='utf-8') as direct_file:
            direct_file.write(f"{direct_rule_content}\n")

if __name__ == "__main__":
    processed_links = set()  # 用于保存已处理的链接

    for filename in os.listdir(input_directory):
        if filename.endswith(".txt") or filename.endswith(".json"):
            input_path = os.path.join(input_directory, filename)
            process_file(input_path, output_directory, processed_links)
