FROM denoland/deno:1.39.4

WORKDIR config

COPY . .

CMD ["bash"]
