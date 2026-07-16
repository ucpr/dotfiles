FROM denoland/deno:2.9.3

WORKDIR config

COPY . .

CMD ["bash"]
