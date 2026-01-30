FROM denoland/deno:2.6.7

WORKDIR config

COPY . .

CMD ["bash"]
