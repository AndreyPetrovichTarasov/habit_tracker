FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - \
    && ln -s /root/.local/bin/poetry /usr/local/bin/poetry
ENV PATH="/root/.local/bin:$PATH"

# Копируем файлы Poetry для установки зависимостей
COPY pyproject.toml poetry.lock /app/

# Устанавливаем зависимости
RUN poetry install --no-dev

# Копируем остальные файлы проекта
COPY . .

RUN mkdir -p /app/media

# Открываем порт для Django
EXPOSE 8000

# Устанавливаем команду по умолчанию для контейнера
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
