FROM denoland/deno:2.6.4

WORKDIR config

COPY . .

CMD ["bash"]
