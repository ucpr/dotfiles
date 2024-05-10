FROM denoland/deno:1.43.2

WORKDIR config

COPY . .

CMD ["bash"]
