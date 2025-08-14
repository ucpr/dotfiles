FROM denoland/deno:2.4.4

WORKDIR config

COPY . .

CMD ["bash"]
