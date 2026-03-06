FROM denoland/deno:2.7.4

WORKDIR config

COPY . .

CMD ["bash"]
