FROM denoland/deno:2.7.11

WORKDIR config

COPY . .

CMD ["bash"]
