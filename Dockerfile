FROM denoland/deno:1.42.2

WORKDIR config

COPY . .

CMD ["bash"]
