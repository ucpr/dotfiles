FROM denoland/deno:1.43.1

WORKDIR config

COPY . .

CMD ["bash"]
