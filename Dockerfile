FROM denoland/deno:2.6.6

WORKDIR config

COPY . .

CMD ["bash"]
