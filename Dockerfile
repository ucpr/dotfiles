FROM denoland/deno:2.7.12

WORKDIR config

COPY . .

CMD ["bash"]
