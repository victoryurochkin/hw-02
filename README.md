# Домашнее задание к занятию «Основы Terraform. Yandex Cloud» — Юрочкин В.А.

## Цели задания

В рамках домашнего задания были выполнены следующие цели:

- созданы ресурсы в Yandex Cloud с помощью Terraform;
- освоена работа с переменными Terraform;
- настроен провайдер Yandex Cloud;
- создана виртуальная машина с публичным IP-адресом;
- выполнено подключение к ВМ по SSH;
- выполнена проверка внешнего IP-адреса через `curl ifconfig.me`;
- выполнен рефакторинг Terraform-кода с использованием переменных, `locals`, `map(object)` и общего `metadata`.

---

## Задание 0

Ознакомился с документацией по `security-groups` в Yandex Cloud. Этот функционал будет использоваться в следующих занятиях для управления сетевым доступом к облачным ресурсам.

---

## Задание 1

### Условие

Необходимо было:

1. Убедиться, что версия Terraform соответствует `~> 1.12.0`.
2. Изучить проект и переменные для Yandex provider.
3. Создать сервисный аккаунт и ключ `service_account_key_file`.
4. Сгенерировать или использовать текущий SSH-ключ и записать его public-часть в `vms_ssh_public_root_key`.
5. Инициализировать проект, исправить синтаксические ошибки и выполнить код.
6. Подключиться к ВМ по SSH под пользователем `ubuntu`.
7. Выполнить команду:

```bash
curl ifconfig.me
```

8. Ответить, как в обучении могут пригодиться параметры `preemptible = true` и `core_fraction = 5`.

---

### Используемые версии

В проекте используется версия Terraform, соответствующая требованию задания:

```hcl
terraform {
  required_version = "~> 1.12.0"
}
```

Используемый провайдер Yandex Cloud:

```hcl
required_providers {
  yandex = {
    source  = "yandex-cloud/yandex"
    version = "0.140.0"
  }
}
```

---

### Структура проекта

В репозитории размещены основные Terraform-файлы:

```text
.
├── main.tf
├── provider.tf
├── variables.tf
├── vms_platform.tf
├── locals.tf
├── outputs.tf
├── .gitignore
└── README.md
```

Файлы с секретами и локальным состоянием Terraform не публикуются в GitHub:

```text
terraform.tfvars
*.tfstate
*.tfstate.*
key.json
key.old.*.json
.terraform/
```

---

### Настройка провайдера Yandex Cloud

В файле `provider.tf` настроен провайдер Yandex Cloud.

Для авторизации используется ключ сервисного аккаунта:

```hcl
provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
```

Путь к ключу сервисного аккаунта передаётся через переменную:

```hcl
variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud service account key JSON file"
  sensitive   = true
}
```

Сам файл ключа `key.json` не загружается в GitHub и добавлен в `.gitignore`.

---

### Основные переменные Terraform

В файле `variables.tf` объявлены общие переменные для подключения к Yandex Cloud:

```hcl
variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "zone" {
  type        = string
  description = "Yandex Cloud availability zone"
  default     = "ru-central1-b"
}

variable "existing_subnet_id" {
  type        = string
  description = "Existing Yandex Cloud subnet ID"
  default     = "e2lt5rhm75gtha6stmuh"
}

variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key for VM access"
}

variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud service account key JSON file"
  sensitive   = true
}
```

Открытая часть SSH-ключа была записана в переменную:

```hcl
vms_ssh_public_root_key = "ssh-ed25519 ..."
```

---

### Создание первой виртуальной машины

Первая виртуальная машина была создана с именем:

```text
develop
```

Основные параметры:

```text
platform_id   = standard-v1
cores         = 2
memory        = 2
core_fraction = 5
disk_size     = 10
disk_type     = network-hdd
nat           = true
preemptible   = true
zone          = ru-central1-b
```

Так как в облаке был достигнут лимит на создание новых VPC-сетей, для выполнения задания была использована существующая подсеть Yandex Cloud:

```text
e2lt5rhm75gtha6stmuh
```

---

### Исправленные ошибки

В процессе выполнения задания были исправлены следующие ошибки и проблемы конфигурации.

#### 1. Дублирующиеся provider-файлы

В проекте одновременно присутствовали несколько файлов с настройкой провайдера:

```text
provider.tf
providers.tf
versions.tf
```

Это могло приводить к конфликтам конфигурации Terraform. Лишние файлы были удалены, оставлен один корректный файл `provider.tf`.

#### 2. Ошибка загрузки провайдера Yandex Cloud

Terraform не мог загрузить провайдер Yandex Cloud. Для Windows был настроен файл:

```text
%APPDATA%\terraform.rc
```

В нём было указано зеркало Terraform provider для Yandex Cloud.

#### 3. Некорректная настройка авторизации

Был исправлен способ авторизации провайдера Yandex Cloud. Итоговая конфигурация использует:

```hcl
service_account_key_file = var.service_account_key_file
```

Путь к файлу ключа хранится в `terraform.tfvars`, который не публикуется в GitHub.

#### 4. Превышение квоты на создание VPC-сетей

При попытке создать новую VPC-сеть возникала ошибка превышения квоты. Поэтому конфигурация была изменена на использование существующей подсети Yandex Cloud.

#### 5. Проблемы с правами и биллингом

В процессе выполнения возникали ошибки `PermissionDenied` при создании ВМ. Для диагностики проверялись:

- права пользователя;
- права сервисного аккаунта;
- привязка cloud к billing account;
- роли на cloud и folder;
- возможность создания ВМ через `yc compute instance create`.

После настройки billing account и прав создание ВМ стало возможным.

#### 6. Несовместимость `core_fraction = 5` с `standard-v3`

Для платформы `standard-v3` значение `core_fraction = 5` недоступно. Поэтому для выполнения условия задания была использована платформа:

```hcl
platform_id = "standard-v1"
```

Это позволило использовать:

```hcl
core_fraction = 5
```

---

### Инициализация и проверка Terraform

Были выполнены команды:

```bash
terraform init
terraform fmt
terraform validate
terraform apply
```

Проверка конфигурации завершилась успешно:

```text
Success! The configuration is valid.
```

После выполнения `terraform apply` была создана виртуальная машина:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

<img width="2489" height="1441" alt="image" src="https://github.com/user-attachments/assets/04c3ec3e-47a6-4834-b350-f4d23d73b01c" />

---

### Результат создания первой ВМ

После создания ВМ были получены следующие outputs:

```text
ssh_command = "ssh ubuntu@158.160.29.121"
vm_external_ip = "158.160.29.121"
vm_internal_ip = "10.129.0.21"
vm_name = "develop"
```

<img width="1855" height="1051" alt="image" src="https://github.com/user-attachments/assets/63759bff-415d-49d4-8b6e-91cbb727bc1a" />

---

### Подключение к ВМ по SSH

Подключение выполнено командой:

```bash
ssh ubuntu@158.160.29.121
```

Так как используется образ Ubuntu, подключение выполнялось под пользователем:

```text
ubuntu
```

<img width="1453" height="1317" alt="image" src="https://github.com/user-attachments/assets/577e9921-e0ee-43af-bc68-2d74268377eb" />

---

### Проверка внешнего IP-адреса

На виртуальной машине была выполнена команда:

```bash
curl ifconfig.me
```

Результат:

```text
158.160.29.121
```

IP-адрес, полученный через `curl ifconfig.me`, совпадает с внешним IP-адресом ВМ в Yandex Cloud:

```text
158.160.29.121
```

<img width="1307" height="104" alt="image" src="https://github.com/user-attachments/assets/de0543f5-69fc-412a-bc53-c1e9665a2bed" />

---

### Скриншот ЛК Yandex Cloud

В личном кабинете Yandex Cloud создана ВМ `develop`, где виден внешний IP-адрес:

```text
158.160.29.121
```

<img width="2951" height="596" alt="image" src="https://github.com/user-attachments/assets/62b9cf6d-0d2e-41e4-a82e-71e9f0daf7fd" />

---

### Скриншот консоли с `curl ifconfig.me`

В консоли SSH-подключения выполнена команда:

```bash
curl ifconfig.me
```

Команда отобразила внешний IP:

```text
158.160.29.121
```

<img width="1367" height="1411" alt="image" src="https://github.com/user-attachments/assets/218415c0-0462-4427-9c7b-46083ef37720" />

---

### Ответ на вопрос про `preemptible = true`

Параметр:

```hcl
preemptible = true
```

создаёт прерываемую виртуальную машину.

Такая ВМ стоит дешевле обычной, но может быть остановлена облачной платформой. В процессе обучения это полезно, потому что учебный стенд обычно не требует постоянной доступности. Это позволяет экономить грант или средства на платёжном аккаунте.

---

### Ответ на вопрос про `core_fraction = 5`

Параметр:

```hcl
core_fraction = 5
```

задаёт минимальную гарантированную долю производительности vCPU.

Это снижает стоимость виртуальной машины. Для учебных задач, таких как проверка Terraform-кода, SSH-подключение и выполнение простых команд, высокой производительности не требуется, поэтому `core_fraction = 5` подходит для экономии ресурсов.

---

## Задание 2

### Условие

Необходимо было заменить все хардкод-значения для ресурсов `yandex_compute_image` и `yandex_compute_instance` на отдельные переменные. К названиям переменных ВМ нужно было добавить префикс `vm_web_`.

---

### Выполнение

В рамках задания были заменены хардкод-значения в ресурсах:

```hcl
data "yandex_compute_image" "ubuntu"
resource "yandex_compute_instance" "platform"
```

Для переменных виртуальной машины использован префикс `vm_web_`, например:

- `vm_web_image_family`;
- `vm_web_name`;
- `vm_web_hostname`;
- `vm_web_platform_id`;
- `vm_web_cores`;
- `vm_web_memory`;
- `vm_web_core_fraction`;
- `vm_web_disk_size`;
- `vm_web_disk_type`;
- `vm_web_nat`;
- `vm_web_ssh_user`;
- `vm_web_preemptible`.

Все переменные были объявлены с указанием типа. Для новых переменных были заданы значения `default`, соответствующие прежним значениям из `main.tf`.

После выполнения изменений были запущены команды:

```bash
terraform fmt
terraform validate
terraform plan
```

Результат:

```text
No changes. Your infrastructure matches the configuration.
```

Это означает, что хардкод был заменён на переменные без изменения уже созданной инфраструктуры.

<img width="2282" height="1389" alt="image" src="https://github.com/user-attachments/assets/d01848e2-85c7-46da-bbfb-a897133e18dc" />

---

## Задание 3

### Условие

Необходимо было:

1. Создать в корне проекта файл `vms_platform.tf`.
2. Перенести в него все переменные первой ВМ.
3. Скопировать блок ресурса и создать с его помощью вторую ВМ:
   - `netology-develop-platform-db`;
   - `cores = 2`;
   - `memory = 2`;
   - `core_fraction = 20`;
   - зона `ru-central1-b`.
4. Объявить переменные второй ВМ с префиксом `vm_db_` в файле `vms_platform.tf`.
5. Применить изменения.

---

### Выполнение

Создан файл:

```text
vms_platform.tf
```

В него перенесены переменные первой виртуальной машины с префиксом `vm_web_`.

Также в `vms_platform.tf` добавлены переменные второй виртуальной машины с префиксом `vm_db_`.

В файле `main.tf` добавлен второй ресурс:

```hcl
resource "yandex_compute_instance" "platform_db"
```

Вторая ВМ создана со следующими параметрами:

```text
name          = netology-develop-platform-db
zone          = ru-central1-b
cores         = 2
memory        = 2
core_fraction = 20
```

После выполнения `terraform plan` было показано создание одной новой ВМ:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

<img width="2949" height="721" alt="image" src="https://github.com/user-attachments/assets/068f13e0-8970-476d-a9ef-acec268a818c" />

После выполнения `terraform apply` изменения были успешно применены.

<img width="1792" height="1580" alt="image" src="https://github.com/user-attachments/assets/a191bf4e-a468-4b46-be54-656f2193492c" />

---

## Задание 4

### Условие

Необходимо было объявить в файле `outputs.tf` один output, содержащий:

- `instance_name`;
- `external_ip`;
- `fqdn`;

для каждой из ВМ без хардкода.

Также нужно было применить изменения и приложить вывод значений IP-адресов команды:

```bash
terraform output
```

---

### Выполнение

В файле `outputs.tf` объявлен один общий output:

```hcl
output "vms_info" {
  description = "Information about created virtual machines"

  value = {
    web = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.fqdn
    }

    db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform_db.fqdn
    }
  }
}
```

Значения не захардкожены, а берутся напрямую из ресурсов Terraform.

После применения изменений была выполнена команда:

```bash
terraform output
```

<img width="2035" height="1536" alt="image" src="https://github.com/user-attachments/assets/64d4f6ed-7695-45f7-918d-b971337049ab" />

<img width="1982" height="1555" alt="image" src="https://github.com/user-attachments/assets/b85f2096-02be-4b56-9e16-9d9d391e8a98" />

---

## Задание 5

### Условие

Необходимо было:

1. Создать файл `locals.tf`.
2. В одном `local`-блоке описать имя каждой ВМ.
3. Использовать интерполяцию `${...}` с несколькими переменными.
4. Заменить переменные внутри ресурса ВМ на созданные local-переменные.
5. Применить изменения.

---

### Выполнение

В корне проекта создан файл:

```text
locals.tf
```

В одном `local`-блоке описаны имена виртуальных машин:

```hcl
locals {
  vm_web_instance_name = "${var.vm_web_name_prefix}${var.vm_web_name}${var.vm_web_name_suffix}"
  vm_db_instance_name  = "${var.vm_db_name_prefix}${var.vm_db_env}-${var.vm_db_platform}-${var.vm_db_role}"
}
```

Имена ВМ собираются через интерполяцию `${...}` с использованием нескольких переменных.

В файле `main.tf` значения `name` и `hostname` для ресурсов ВМ заменены на local-переменные:

```hcl
name     = local.vm_web_instance_name
hostname = local.vm_web_instance_name
```

и:

```hcl
name     = local.vm_db_instance_name
hostname = local.vm_db_instance_name
```

После внесения изменений были выполнены команды:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Изменения применены успешно.

<img width="2292" height="1282" alt="image" src="https://github.com/user-attachments/assets/00951d31-ef37-4e7c-af8b-9b360456933e" />

<img width="1754" height="1503" alt="image" src="https://github.com/user-attachments/assets/ad9affe1-e172-484f-ae8f-199c62e350e4" />

---

## Задание 6

### Условие

Необходимо было:

1. Вместо переменных `.._cores`, `.._memory`, `.._core_fraction` в блоке `resources {...}` использовать единую map-переменную `vms_resources`.
2. Внутри неё описать конфигурации обеих ВМ в виде вложенного `map(object)`.
3. Создать и использовать отдельную map-переменную для блока `metadata`, общую для всех ВМ.
4. Найти и закомментировать все более не используемые переменные проекта.
5. Проверить `terraform plan`. Изменений быть не должно.

---

### Выполнение

В блоке `resources` больше не используются отдельные переменные вида:

- `vm_web_cores`;
- `vm_web_memory`;
- `vm_web_core_fraction`;
- `vm_db_cores`;
- `vm_db_memory`;
- `vm_db_core_fraction`.

Вместо них создана единая переменная `vms_resources` типа `map(object(...))`:

```hcl
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    nat           = bool
    preemptible   = bool
  }))
}
```

Внутри неё описаны конфигурации для обеих ВМ:

```hcl
vms_resources = {
  web = {
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    nat           = true
    preemptible   = true
  }

  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    hdd_size      = 10
    hdd_type      = "network-hdd"
    nat           = true
    preemptible   = true
  }
}
```

Также создана общая переменная `metadata` типа `map(string)`, которая используется в обеих ВМ:

```hcl
metadata = var.metadata
```

Пример значения в `terraform.tfvars`:

```hcl
metadata = {
  ssh-keys = "ubuntu:ssh-ed25519 ..."
}
```

Более не используемые переменные были закомментированы в файле:

```text
vms_platform.tf
```

После изменений были выполнены команды:

```bash
terraform fmt
terraform validate
terraform plan
```

Результат:

```text
No changes. Your infrastructure matches the configuration.
```

Это означает, что рефакторинг выполнен без изменения уже созданной инфраструктуры.

<img width="2061" height="1524" alt="image" src="https://github.com/user-attachments/assets/a9654162-7811-4150-866a-94532ab276b5" />

<img width="1776" height="1488" alt="image" src="https://github.com/user-attachments/assets/fc551463-50ba-4c8f-8ccf-924a33979e8f" />

<img width="1751" height="1556" alt="image" src="https://github.com/user-attachments/assets/2597e71a-8a64-413b-b18d-743e4d0fdee9" />

---

## Итог

Все задания выполнены.

В результате:

- Terraform-код размещён в GitHub;
- создана первая ВМ `develop`;
- создана вторая ВМ `netology-develop-platform-db`;
- выполнено подключение к первой ВМ по SSH;
- команда `curl ifconfig.me` вернула внешний IP, совпадающий с IP в Yandex Cloud;
- хардкод-значения вынесены в переменные;
- переменные ВМ разделены по префиксам `vm_web_` и `vm_db_`;
- создан файл `vms_platform.tf`;
- создан файл `locals.tf`;
- имена ВМ формируются через `locals`;
- создан один общий output `vms_info`;
- ресурсы ВМ вынесены в `vms_resources`;
- `metadata` сделан общим для всех ВМ;
- более не используемые переменные закомментированы.
