FROM denoland/deno:1.46.3

WORKDIR config

COPY . .

CMD ["bash"]
