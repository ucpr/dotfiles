FROM denoland/deno:1.42.1

WORKDIR config

COPY . .

CMD ["bash"]
