FROM denoland/deno:2.7.7

WORKDIR config

COPY . .

CMD ["bash"]
