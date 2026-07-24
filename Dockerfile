FROM denoland/deno:2.9.4

WORKDIR config

COPY . .

CMD ["bash"]
