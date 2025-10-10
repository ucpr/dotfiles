FROM denoland/deno:2.5.4

WORKDIR config

COPY . .

CMD ["bash"]
