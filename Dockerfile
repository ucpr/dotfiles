FROM denoland/deno:1.39.2

WORKDIR config

COPY . .

CMD ["bash"]
