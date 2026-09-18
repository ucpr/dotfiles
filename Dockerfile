FROM denoland/deno:2.9.7

WORKDIR config

COPY . .

CMD ["bash"]
